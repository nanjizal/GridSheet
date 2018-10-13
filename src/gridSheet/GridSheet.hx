package gridSheet;
import kha.Image;
import kha.graphics2.Graphics;
typedef GridSheetDef = {
    var gridX:      Float;
    var gridY:      Float;
    var totalRows:  Int;
    var totalCols:  Int;
    var scaleX:     Float;
    var scaleY:     Float;
    var image:      Image;
}
typedef Position = {
    function getXY( row: Int, col: Int ): { x: Float, y: Float };
    function getAlpha( row: Int, col: Int ): Float;
}
class GridSheet{
    var gridX:      Float;
    var gridY:      Float;
    var scaleX:     Float;
    var scaleY:     Float;
    var totalRows:  Int;
    var totalCols:  Int;
    var r:          Int = 0;
    var c:          Int = 0;
    var count:      Int = 0;
    var image:      Image;
    public var totalCount: Float = 8;
    public function new( gi: GridSheetDef ){
        gridX       = gi.gridX;
        gridY       = gi.gridY;
        totalRows   = gi.totalRows;
        totalCols   = gi.totalCols;
        scaleX      = gi.scaleX;
        scaleY      = gi.scaleY;
        image       = gi.image;
    }
    public function renderGrid( g: Graphics, pos: Position ){
        var p: { x: Float, y: Float };
        var alpha: Float;
        for( col in 0...totalCols ){
            for( row in 0...totalRows ){
                renderFrame( g, pos, row, col );
            }
        }
        // assume to reset it to 1.
        g.opacity = 1.;
    }
    public function renderSequence( g: Graphics, pos: Position ){
        renderFrame( g, pos, r, c );
        advanceFrame();
    }
    inline function renderFrame( g: Graphics, pos: Position, row: Int, col: Int ){
        var p: { x: Float, y: Float } = pos.getXY( row, col );
        g.opacity = pos.getAlpha( row, col );
        g.drawScaledSubImage( image
                            , row*gridX, col*gridY
                            , gridX, gridY
                            , p.x, p.y
                            , gridX * scaleX, gridY * scaleY );
    }
    inline function advanceFrame(){
        if( count == totalCount ){
            count = 0;
            r++;
            if( r > totalRows - 1 ){
                r = 0;
                c++;
                if( c > totalCols - 1 ){
                    c = 0;
                }
            }
        }
        count++;
    }
    // defaults you can pass GridSheet as Position
    inline function getXY( row: Int, col: Int ):{x: Float, y: Float }{
        return { x: scaleX*row*gridX, y: scaleY*col*gridY };
    }
    inline function getAlpha( row: Int, col: Int ): Float {
        return 1.;
    }
}
class SequenceSprite{
    public var x: Float = 0;
    public var y: Float = 0;
    public var alpha: Float = 0;
    public function new( x_: Float, y_: Float, alpha_: Float ){
        x = x_;
        y = y_;
        alpha = alpha_;
    }
    inline function getXY( row: Int, col: Int ):{x: Float, y: Float }{
        return { x: x, y: y };
    }
    inline function getAlpha( row: Int, col: Int ): Float {
        return alpha;
    }
}