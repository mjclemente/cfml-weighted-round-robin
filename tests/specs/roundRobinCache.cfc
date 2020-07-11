/**
* My BDD Test
*/
component extends="testbox.system.BaseSpec" {

  /*********************************** LIFE CYCLE Methods ***********************************/

  // executes before all suites+specs in the run() method
  function beforeAll() {
  }

  // executes after all suites+specs in the run() method
  function afterAll() {
  }

  /*********************************** BDD SUITES ***********************************/

  function run( testResults, testBox ) {
    // all your suites go here.
    describe( 'The Round Robin cache', function() {
      beforeEach( function( currentSpec ) {
        variables.RoundRobin = new RoundRobin( 'dummy', 'test' );
        RoundRobin.wipe();
      } );

      it( 'can add items to the Round Robin', function() {
        RoundRobin.add( {
          weight: 25,
          id: 1
        } );
        RoundRobin.add( {
          weight: 25,
          id: 2
        } );

        expect( RoundRobin.size() ).toBe( 2 );
      } );

      it( 'can remove items from the Round Robin', function() {
        RoundRobin.add( {
          weight: 25,
          id: 1
        } );
        RoundRobin.add( {
          weight: 25,
          id: 2
        } );

        RoundRobin.remove( 2 );
        expect( RoundRobin.size() ).toBe( 1 );
      } );

      it( 'properly rotates the elements', function() {
        RoundRobin.add( {
          weight: 3,
          id: 'one'
        } );
        RoundRobin.add( {
          weight: 5,
          id: 'two'
        } );
        RoundRobin.add( {
          weight: 2,
          id: 'three'
        } );
        var rotation = [ ];
        for ( var i = 0; i < 10; i++ ) {
          rotation.append( RoundRobin.get().id );
        }

        var oneOccurrences = rotation.findAll('one').len();
        var twoOccurrences = rotation.findAll('two').len();;
        var threeOccurrences = rotation.findAll('three').len();;                         

        expect( oneOccurrences ).toBe( 3 );
        expect( twoOccurrences ).toBe( 5 );
        expect( threeOccurrences ).toBe( 2 );
      } );

      it( 'can reset the relative weights', function() {
        RoundRobin.add( {
          weight: 6,
          id: 1
        } );
        RoundRobin.add( {
          weight: 4,
          id: 2
        } );
        RoundRobin.add( {
          weight: 7,
          id: 3
        } );

        for ( var i = 0; i < 5; i++ ) {
          RoundRobin.get();
        }
        RoundRobin.reset();

        expect( RoundRobin.get().id ).toBe( 3 );
        expect( RoundRobin.get().id ).toBe( 1 );
        expect( RoundRobin.get().id ).toBe( 2 );
      } );

      it( 'throws an error if there is no id', function() {
        expect( function() {
          RoundRobin.add( {
            weight: 25
          } )
        } ).toThrow();
      } );

      it( 'can overwrite existing elements', function() {
        RoundRobin.add( {
          weight: 7,
          id: 1
        } );
        RoundRobin.add(
          {
            weight: 5,
            id: 1
          },
          true
        );

        var elements = RoundRobin.expose();

        expect( elements[ '1' ].weight ).toBe( 5 );
      } );
    } );
  }

}

