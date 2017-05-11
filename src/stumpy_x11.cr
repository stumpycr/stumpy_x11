require "stumpy_core"
require "./stumpy_x11/x11"

class StumpyX11
  include StumpyCore

  @display : LibX11::Display
  @screen : Int32
  @visual : Pointer(LibX11::Visual)
  @window : LibX11::Window
  @gc : LibX11::Gc
  @image : Pointer(LibX11::Image)
  @buffer : Slice(Int32)

  getter width : Int32
  getter height : Int32

  def initialize(@width, @height)
    display_number = 0_u8
    @display = LibX11.open_display(pointerof(display_number))
    raise "Could not open display" if @display == 0

    @screen = LibX11.default_screen(@display)
    @visual = LibX11.default_visual(@display, @screen)

    formatcount = 0
    formats = LibX11.list_pixmap_formats(@display, pointerof(formatcount))

    depth = LibX11.default_depth(@display, @screen)
    default_root_window = LibX11.default_root_window(@display)

    conv_depth = -1

    (0...formatcount).each do |i|
      if depth == formats[i].depth
        conv_depth = formats[i].bits_per_pixel
        break
      end
    end

    LibX11.free(formats)

    if conv_depth != 32
      LibX11.close_display(@display)
      raise "Only 32-bit supported right now"
    end

    screen_width = LibX11.display_width(@display, @screen)
    screen_height = LibX11.display_height(@display, @screen)

    window_attrs = LibX11::SetWindowAttributes.new(
      border_pixel: LibX11.black_pixel(@display, @screen),
      background_pixel: LibX11.black_pixel(@display, @screen),
      backing_store: LibX11::NOTUSEFUL
    )

    @window = LibX11.create_window(
      @display,
      default_root_window,
      (screen_width - width) / 2,
      (screen_height - height) / 2,
      width,
      height,
      0,
      depth,
      LibX11::INPUTOUTPUT,
      @visual,
      LibX11::CWBACKPIXEL | LibX11::CWBORDERPIXEL | LibX11::CWBACKINGSTORE,
      pointerof(window_attrs)
    )

    size_hints = LibX11::SizeHints.new(
      flags: LibX11::PPosition | LibX11::PMinSize | LibX11::PMaxSize,
      x: 0,
      y: 0,
      min_width: 0,
      max_width: 0,
      min_height: 0,
      max_height: 0,
    )

    LibX11.set_wm_normal_hints(@display, @window, pointerof(size_hints))
    LibX11.clear_window(@display, @window)
    LibX11.map_raised(@display, @window)
    LibX11.flush(@display)

    @gc = LibX11.default_gc(@display, @screen)

    @image = LibX11.create_image(
      @display,
      Pointer(LibX11::Visual).new(LibX11::COPYFROMPARENT),
      depth,
      LibX11::ZPIXMAP,
      0,
      nil,
      width,
      height,
      32,
      width * 4
    )

    @buffer = Slice(Int32).new(width * height)
  end

  def write(buffer : Slice(Int32))
    @image.value.data = buffer.to_unsafe.as(Pointer(UInt8))
    LibX11.put_image(@display, @window, @gc, @image, 0, 0, 0, 0, @width, @height)
    LibX11.flush(@display)
  end

  def write(canvas : StumpyCore::Canvas)
    (0...width).each do |x|
      (0...height).each do |y|
        pixel = canvas[x, y]
        r = pixel.r.to_i32 >> 8
        g = pixel.g.to_i32 >> 8
        b = pixel.b.to_i32 >> 8

        @buffer[x + y*width] = (r << 16) | (g << 8) | b
      end
    end

    write(@buffer)
  end

  def destroy
    @image.value.data = Pointer(UInt8).null
    @image.value.f.destroy_image.call(@image)
    LibX11.destroy_window(@display, @window)
    LibX11.close_display(@display)
  end
end
