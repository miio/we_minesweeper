class Room < ActiveRecord::Base
  paginates_per 25
  attr_accessible :level
  has_many :panels
  belongs_to :author, class_name: "User"
  after_create :after_create_callback
  @cached_structure
  LEVEL = { easy: 1, normal:2, hard:3 }
  PANEL = {
    LEVEL[:easy]   => [9,9],
    LEVEL[:normal] => [16,16],
    LEVEL[:hard]   => [30,16]
  }

  def get_room_ranking
    Panel.select("count(panels.id) as count, users.*").where(is_bomb: false, is_open: true, room_id: self).group("panels.user_id").limit(5).all(joins: :user)
  end

  def after_create_callback
    panel = []
    (1..(PANEL[self.level].first)).each do|w|
      (1..(PANEL[self.level].last)).each do |h|
        panel << Panel.new(width: w, height: h, room: self)
      end
    end
    Panel.import panel
    self.initialize_set
  end

  def initialize_set
    noset = Panel::BOMB[self.level]
    panels = self.panels.sort_by{rand}
    panels.each do |panel|
      panel.bomb_flag = panel.calc_bomb_flag
      if noset > 0
        panel.is_bomb = true
        noset -= 1
      end
      if panels.last == panel
        logger.debug "save and cache clear"
        panel.save_with_clear_cache
      else
        logger.debug "update"
        panel.save
      end
    end

    logger.debug "initialize completed"

  end

  def level= level
    write_attribute :level, LEVEL[level]
  end

  def to_s
    result = ""
    disp = self.get_structure
    disp.each_pair do |k, width|
      result += "\n-----------------------\n"
      width.each_pair do |k, height|
        result += "|#{height}|"
      end
      result += "\n-----------------------\n"
    end
    return result
  end

  def get_structure
    if @cached_structure.nil?
      panels = self.panels.all
      disp = Hash.new { |hash,key| hash[key] = {} }
      panels.each do |panel|
        disp[panel.width][panel.height] = panel
      end
      @cached_structure = disp
      return disp
    else
      return @cached_structure
    end
  end

  def clear_structure_cache
    @cached_structure = nil
  end
end
