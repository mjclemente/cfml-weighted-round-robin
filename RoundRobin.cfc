/**
* RoundRobin.cfc
* Copyright 2020 Matthew Clemente
* Licensed under MIT (https://mit-license.org)
*/
component output="false" {

  public any function init( string cacheId = '', string cacheRegion = 'object' ) {
    variables.cacheExists = cacheId.len();
    variables.append( arguments );
    variables.serverVersion = server.keyExists( 'lucee' ) ? 'Lucee' : 'ColdFusion';

    variables._elementMap = { };

    return this;
  }

  public boolean function hasCache() {
    return variables.cacheExists;
  }

  public boolean function isLucee() {
    return variables.serverVersion == 'Lucee';
  }

  /**
  * @hint centralized location for checking cache, if applicable, and ensuring the local element map is up-to-date
  */
  private void function verifyCache() {
    if ( hasCache() ) {
      variables._elementMap = cacheGet( id = variables.cacheId, region = variables.cacheRegion ) ?: { };
    }
  }

  private void function updateCache() {
    if ( hasCache() ) {
      if ( isLucee() ) {
        cachePut( id = variables.cacheId, value = variables._elementMap, region = variables.cacheRegion );
      } else {
        cachePut(
          id = variables.cacheId,
          value = variables._elementMap,
          timespan = '',
          idletime = '',
          region = variables.cacheRegion
        );
      }
    }
  }

  public numeric function size() {
    verifyCache();
    return variables._elementMap.keyArray().len();
  }

  public struct function expose() {
    verifyCache();
    return variables._elementMap.duplicate();
  }

  public string function add( required struct element, boolean overwrite = true ) {
    verifyCache();

    // the id makes adding far easier if there is any type of persistence
    if ( !element.keyExists( 'id' ) ) {
      throw( 'Elements must include a unique id so they can be managed within the round robin.' );
    }

    var key = element.id;

    // if we're overwriting, or it doesn't exist, add it. Otherwise, don't do anything, because we're already tracking the id
    if ( overwrite || !variables._elementMap.keyExists( key ) ) {
      variables._elementMap[ key ] = _reset( element );
    }


    updateCache();
    return key;
  }

  public void function remove( required any key ) {
    verifyCache();
    variables._elementMap.delete( key );
    updateCache();
  }

  public void function reset() {
    verifyCache();
    variables._elementMap.each( function( key, element ) {
      _reset( element );
    } );
    updateCache();
  }

  public void function wipe() {
    variables._elementMap = { };
    updateCache();
  }

  private struct function _reset( required struct element ) {
    element[ 'weight' ] = element?.weight ?: 10;
    element[ 'currentWeight' ] = element.weight;
    element.effectiveWeight = element.weight;

    return element;
  }

  public struct function get() {
    verifyCache();
    var bestElement = { };
    var element = { };
    var length = size();

    if ( !length ) {
      throw( 'There are no elements to return.' );
    }

    if ( length == 1 ) {
      return variables._elementMap[ 1 ];
    }

    var totalEffectiveWeight = 0;

    variables._elementMap.each( function( key, element ) {
      totalEffectiveWeight += element.effectiveWeight;
      element.currentWeight += element.effectiveWeight;

      if ( element.effectiveWeight < element.weight ) {
        element.effectiveWeight++;
      }
      if ( bestElement.isEmpty() || bestElement.currentWeight < element.currentWeight ) {
        bestElement = element;
      }
    } );

    bestElement.currentWeight -= totalEffectiveWeight;
    updateCache();
    return bestElement;
  }

}
