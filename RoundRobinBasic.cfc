/**
* RoundRobin.cfc
* Copyright 2020 Matthew Clemente
* Licensed under MIT (https://mit-license.org)
*/
component output="false" {

  public any function init() {
    variables._elementMap = { };

    return this;
  }

  public numeric function size() {
    return variables._elementMap.keyArray().len();
  }

  public struct function expose() {
    return variables._elementMap.duplicate();
  }

  public string function add( required struct element ) {
    var key = element.keyExists( 'id' )
     ? element.id
     : createUUID();

    variables._elementMap[ key ] = _reset( element );
    return key;
  }

  public void function remove( required any key ) {
    variables._elementMap.delete( key );
  }

  public void function reset() {
    variables._elementMap.each( function( key, element ) {
      _reset( element );
    } );
  }

  private struct function _reset( required struct element ) {
    element[ 'weight' ] = element?.weight ?: 10;
    element[ 'currentWeight' ] = element.weight;
    element.effectiveWeight = element.weight;

    return element;
  }

  public struct function get() {
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

    return bestElement;
  }

}
