# stumpy_x11

Display a canvas as a X11 window

## Example

``` crystal
require "stumpy_x11"

include StumpyCore

width, height = 400, 400
window = StumpyX11.new(width, height)
canvas = Canvas.new(width, height)

steps = 100
steps.times do |t|
  (0...width).each do |x|
    (0...height).each do |y|
      canvas[x, y] = RGBA.from_relative(
        x / width.to_f,
        y / height.to_f,
        t / steps.to_f,
        1.0
      )
    end
  end

  window.write(canvas)
  sleep 0.02
end

window.destroy

```

## TODO

* Handle window close event
* Documentation (writing raw slices)

## Credits

* [Daniel Collin (emoon)](https://github.com/emoon), most of the x11 stuff
  was ported over from [emoon/minifb](https://github.com/emoon/minifb)

## Troubleshooting

If you run into errors like `unknown type wchar_t`,
run `ln -s /usr/include/linux/stddef.h /usr/include/stddef.h`
