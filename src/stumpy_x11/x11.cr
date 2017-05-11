@[Link("X11")]
lib LibX11
  CWBACKPIXEL = 1_i64 << 1
  CWBORDERPIXEL = 1_i64 << 3
  CWBACKINGSTORE = 1_i64 << 6

  COPYFROMPARENT = 0
  NOTUSEFUL = 0
  INPUTOUTPUT = 1
  ZPIXMAP = 2

  PPosition	= 1_i64 << 2
  PSize = 1_i64 << 3
  PMinSize = 1_i64 << 4
  PMaxSize = 1_i64 << 5
  PResizeInc = 1_i64 << 6
  PAspect		= 1_i64 << 7
  PBaseSize	= 1_i64 << 8 
  PWinGravity	= 1_i64 << 9 

  type Display = Void*
  type Gc = Void*

  alias Window = LibC::ULong
  alias Pixmap = LibC::ULong
  alias Cursor = LibC::ULong
  alias Colormap = LibC::ULong
  alias Drawable = LibC::ULong

  struct ExtData
    number : LibC::Int
    next : ExtData*
    free_private : (ExtData* -> LibC::Int)
    private_data : LibC::Char*
  end

  struct Visual
    ext_data : ExtData*
    visualid : LibC::ULong
    c_class : LibC::Int
    red_mask : LibC::ULong
    green_mask : LibC::ULong
    blue_mask : LibC::ULong
    bits_per_rgb : LibC::Int
    map_entries : LibC::Int
  end

  struct Image
    width : LibC::Int
    height : LibC::Int
    xoffset : LibC::Int
    format : LibC::Int
    data : LibC::Char*
    byte_order : LibC::Int
    bitmap_unit : LibC::Int
    bitmap_bit_order : LibC::Int
    bitmap_pad : LibC::Int
    depth : LibC::Int
    bytes_per_line : LibC::Int
    bits_per_pixel : LibC::Int
    red_mask : LibC::ULong
    green_mask : LibC::ULong
    blue_mask : LibC::ULong
    obdata : LibC::Char*
    f : ImageFuncs
  end

  struct ImageFuncs
    create_image : (Display*, Visual*, LibC::UInt, LibC::Int, LibC::Int, LibC::Char*, LibC::UInt, LibC::UInt, LibC::Int, LibC::Int -> Image*)
    destroy_image : (Image* -> LibC::Int)
    get_pixel : (Image*, LibC::Int, LibC::Int -> LibC::ULong)
    put_pixel : (Image*, LibC::Int, LibC::Int, LibC::ULong -> LibC::Int)
    sub_image : (Image*, LibC::Int, LibC::Int, LibC::UInt, LibC::UInt -> Image*)
    add_pixel : (Image*, LibC::Long -> LibC::Int)
  end

  fun open_display = XOpenDisplay(x0 : LibC::Char*) : Display
  fun close_display = XCloseDisplay(x0 : Display) : LibC::Int
  fun flush = XFlush(x0 : Display) : LibC::Int

  fun display_width = XDisplayWidth(x0 : Display, x1 : LibC::Int) : LibC::Int
  fun display_height = XDisplayHeight(x0 : Display, x1 : LibC::Int) : LibC::Int

  fun default_visual = XDefaultVisual(x0 : Display, x1 : LibC::Int) : Visual*
  fun default_gc = XDefaultGC(x0 : Display, x1 : LibC::Int) : Gc
  fun default_screen = XDefaultScreen(x0 : Display) : LibC::Int
  fun default_root_window = XDefaultRootWindow(x0 : Display) : Window
  fun default_depth = XDefaultDepth(x0 : Display, x1 : LibC::Int) : LibC::Int

  fun black_pixel = XBlackPixel(x0 : Display, x1 : LibC::Int) : LibC::ULong
  fun white_pixel = XWhitePixel(x0 : Display, x1 : LibC::Int) : LibC::ULong

  struct PixmapFormatValues
    depth : LibC::Int
    bits_per_pixel : LibC::Int
    scanline_pad : LibC::Int
  end

  fun list_pixmap_formats = XListPixmapFormats(x0 : Display, x1 : LibC::Int*) : PixmapFormatValues*

  fun free = XFree(x0 : Void*) : LibC::Int

  struct SetWindowAttributes
    background_pixmap : Pixmap
    background_pixel : LibC::ULong
    border_pixmap : Pixmap
    border_pixel : LibC::ULong
    bit_gravity : LibC::Int
    win_gravity : LibC::Int
    backing_store : LibC::Int
    backing_planes : LibC::ULong
    backing_pixel : LibC::ULong
    save_under : LibC::Int
    event_mask : LibC::Long
    do_not_propagate_mask : LibC::Long
    override_redirect : LibC::Int
    colormap : Colormap
    cursor : Cursor
  end

  fun create_window = XCreateWindow(x0 : Display, x1 : Window, x2 : LibC::Int, x3 : LibC::Int, x4 : LibC::UInt, x5 : LibC::UInt, x6 : LibC::UInt, x7 : LibC::Int, x8 : LibC::UInt, x9 : Visual*, x10 : LibC::ULong, x11 : SetWindowAttributes*) : Window
  fun destroy_window = XDestroyWindow(x0 : Display, x1 : Window) : LibC::Int
  fun clear_window = XClearWindow(x0 : Display, x1 : Window) : LibC::Int

  struct SizeHints
    flags : LibC::Long
    x : LibC::Int
    y : LibC::Int
    width : LibC::Int
    height : LibC::Int
    min_width : LibC::Int
    min_height : LibC::Int
    max_width : LibC::Int
    max_height : LibC::Int
    width_inc : LibC::Int
    height_inc : LibC::Int
    min_aspect : SizeHintsMinAspect
    max_aspect : SizeHintsMinAspect
    base_width : LibC::Int
    base_height : LibC::Int
    win_gravity : LibC::Int
  end
  struct SizeHintsMinAspect
    x : LibC::Int
    y : LibC::Int
  end

  fun set_wm_normal_hints = XSetWMNormalHints(x0 : Display, x1 : Window, x2 : SizeHints*)

  fun map_raised = XMapRaised(x0 : Display, x1 : Window) : LibC::Int

  fun create_image = XCreateImage(x0 : Display, x1 : Visual*, x2 : LibC::UInt, x3 : LibC::Int, x4 : LibC::Int, x5 : LibC::Char*, x6 : LibC::UInt, x7 : LibC::UInt, x8 : LibC::Int, x9 : LibC::Int) : Image*
  fun put_image = XPutImage(x0 : Display, x1 : Drawable, x2 : Gc, x3 : Image*, x4 : LibC::Int, x5 : LibC::Int, x6 : LibC::Int, x7 : LibC::Int, x8 : LibC::UInt, x9 : LibC::UInt) : LibC::Int
  
end
