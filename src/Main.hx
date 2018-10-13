package;
import kha.Framebuffer;
import kha.System;
import kha.Image;
import kha.Assets;
import kha.graphics2.Graphics;
import kha.graphics4.DepthStencilFormat;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
import gridSheet.GridSheet;
import kha.math.FastMatrix3;
class Main {
    var gridX = 50.;
    var gridY = 50.;
    var col = 0;
    var row = 0;
    var totalRows = 10;
    var totalCols = 7;
    var count = 0;
    var totalCount = 8; // speed
    var x = 100.;
    var y = 100.;
    var centreX = 200.;
    var centreY = 200.;
    var radius = 50.;
    var scaleX = 1.5;
    var scaleY = 1.5;    
    var theta = 0.0;
    var rotationSpeed = 0.08;
    var image: Image;
    var gridImage: GridSheet;
    var gridImage2: GridSheet;
    var unicornSequence: GridSheetDef;
    var sequenceSprite: SequenceSprite;
    var matrix = FastMatrix3.identity();
    public static 
    function main() {
        System.init( {  title: "drawSubImage Test"
                     ,  width: 1024, height: 768
                     ,  samplesPerPixel: 4 }
                     , function()
                     {
                        new Main();
                     } );
    }
    public function new(){ Assets.loadEverything( loadAll ); }
    public function loadAll(){
        trace( 'loadAll' );
        image           = Assets.images.colorGrid;
        unicornSequence = { gridX: 132, gridY: 80
                          , totalRows: 8, totalCols: 1
                          , scaleX: 0.7, scaleY: 0.7
                          , image: Assets.images.unicorn };
        sequenceSprite  = new SequenceSprite( 100, 100, 1., FastMatrix3.identity() );
        gridImage       = new GridSheet( cast unicornSequence );
        gridImage2      = new GridSheet( cast unicornSequence );
        startRendering();
        initInputs();
    }
    function startRendering(){
        System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
    }
    function render( framebuffer: Framebuffer ){
        var g: Graphics = framebuffer.g2;
        g.begin( true, 0xFFFFFFFF ); 
        grids( g );
        animate( g );
        g.end();
    }
    inline function grids( g: Graphics ){
        rotatePositionXY( 0 );
        gridImage.renderGrid( g, cast this );   
        theta += rotationSpeed;
    }
    inline function animate( g: Graphics ){
        rotatePositionXY( 0 );
        var dx = ( sequenceSprite.x + unicornSequence.gridX/2 * unicornSequence.scaleX );
        var dy = ( sequenceSprite.y + unicornSequence.gridY/2 * unicornSequence.scaleY );
        sequenceSprite.matrix = FastMatrix3.translation( dx, dy ).multmat( FastMatrix3.rotation( -theta ) ).multmat( FastMatrix3.translation( -dx, -dy ) );
        gridImage2.renderSequence( g, cast sequenceSprite );  
    } 
    inline function getItem( row: Int, col: Int ): GridItemDef {
        rotatePositionXY( row*col );
        return { x: scaleX*row*gridX*1.1 + x - 180 - gridX/2, y: scaleY*col*gridY*1.1 + y - 200 - gridY/2, alpha: 1., transform: FastMatrix3.identity() };
    }
    inline function rotatePositionXY( offset: Float ){
        x = centreX + radius*Math.sin( theta + offset );
        y = centreY + radius*Math.cos( theta + offset );
        sequenceSprite.x = centreX - unicornSequence.gridX/2 * unicornSequence.scaleX;
        sequenceSprite.y = centreY - unicornSequence.gridY/2 * unicornSequence.scaleY; 
    }
    function initInputs() {
        if (Mouse.get() != null) Mouse.get().notify( mouseDown, mouseUp, mouseMove, mouseWheel );
    }

    function mouseDown( button: Int, x: Int, y: Int ): Void {
        trace('down');
    }

    function mouseUp( button: Int, x: Int, y: Int ): Void {
        trace('up');
    }

    function mouseMove( x: Int, y: Int, movementX: Int, movementY: Int ): Void {
        trace('Move');
    }

    function mouseWheel( delta: Int ): Void {
        trace('Wheel');
    }
}
