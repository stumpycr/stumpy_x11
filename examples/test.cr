require "../src/stumpy_x11"

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

