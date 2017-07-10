require 'gosu'

class WhackARuby < Gosu::Window
  def initialize
    super(800, 600)
    self.caption = "Whack the Ruby!"
    #ruby
    @image = Gosu::Image.new('ruby.png')
    @x = 200
    @y  = 200
    @width = 50
    @height = 43
    @velocity_x = 5
    @velocity_y = 5
    @visible = 0
    #hammer
    @hammer_image = Gosu::Image.new('hammer.png')
    #hit
    @hit = 0
    #score
    @font = Gosu::Font.new(30)
    @score = 0
    #is the game over?
    @playing = true
    #time current game started
    @start_time = 0
  end

  def draw
    #ruby
    if @visible > 0
      @image.draw(@x - @width / 2, @y - @height / 2, 1)
    end
    #hammer
    @hammer_image.draw(mouse_x - 40, mouse_y - 10, 1)
    #mouse click
    if @hit == 0
      #leave screen black if no click
      c = Gosu::Color::NONE
    elsif @hit == 1
      #if you hit, change screen to green
      c = Gosu::Color::GREEN
    elsif @hit == -1
      #miss, screen goes red
      c = Gosu::Color::RED
    end
    #actually change the color!
    draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
    @hit = 0
    #score
    @font.draw(@score.to_s, 700, 20, 2)
    #time remaining
    @font.draw(@time_left.to_s, 20, 20, 2)
    #game over!
    unless @playing
      @font.draw('Game Over!', 300, 300, 3)
      #play again?
      @font.draw('Press the Space Bar to Play Again', 175, 350, 3)
      @visible = 20
    end
  end

  def update
    if @playing #as long as playing is true....
      @x += @velocity_x
      @y += @velocity_y
      #check if ruby gets to an edge
      @velocity_x *= -1 if @x + @width / 2 > 800 || @x - @width / 2 < 0
      @velocity_y *= -1 if @y + @height / 2 > 600 || @y - @height / 2 < 0
      #check visiblity
      @visible -= 1
      #visible for 50 frames if it's been invisible for at least 10
      @visible = 50 if @visible < -10 && rand < 0.01
      #time left out of 100s
      @time_left = (100 - ((Gosu.milliseconds - @start_time) / 1000))
      #is the game over yet?
      @playing = false if @time_left <=0
    end
  end

  def button_down(id) #mouse click
    if @playing
      if (id == Gosu::MsLeft) #check for left mouse button click
        if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
          @hit = 1 #yay!
          @score += 5
        else
          @hit = -1 #boo!
          @score -= 1
        end
      end
    #replay game if spacebar is pressed
    else
      if (id == Gosu::KbSpace)
        @playing = true
        @visible = -10
        @start_time = Gosu.milliseconds
        @score = 0
      end
    end
  end

end

window = WhackARuby.new
window.show
