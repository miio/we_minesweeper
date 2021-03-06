class Panel < ActiveRecord::Base
  attr_accessible :is_open, :is_bomb, :width, :height, :room, :bomb_flag
  belongs_to :room
  belongs_to :user
  BOMB = {
    Room::LEVEL[:easy]   => 3,
    Room::LEVEL[:easy]   => 10,
    Room::LEVEL[:normal] => 40,
    Room::LEVEL[:hard]   => 99
  }

  def click user
    Panel.transaction do
      # LockRecord
      lock = Panel.find(self, lock: true)
      unless lock.nil?
        unless lock.is_open?
          # Open this panel
          lock.is_open = true
          lock.user = user
          # open space panel
          lock.open user
          lock.save_with_clear_cache
          # bomb?
          lock.game_over if lock.is_bomb?
          lock.save_with_clear_cache
          # clear?
        end
      end
    end
  end

  def save_with_clear_cache
    self.save
    self.after_save_clear_cache
  end
  def to_s
    return "" if is_open
    return "B" if self.is_bomb
    return self.bomb_flag.to_s unless self.bomb_flag == 0
    return "?"
  end

  def calc_bomb_flag
    count = 0
    structure = self.room.get_structure
    ((self.height-1)..(self.height+1)).each do |h|
      ((self.width-1)..(self.width+1)).each do |w|
        unless self.width == w and self.height == h
          unless structure[w][h].nil?
            if structure[w][h].is_bomb?
              count +=1
            end
          end
        end
      end
    end
    return count
  end

  def open user
    self.open_target_panels self, user
  end

  def open_target_panels panel, user
    target_panel = []
    structure = self.room.get_structure
    ((panel.height-1)..(panel.height+1)).each do |h|
      ((panel.width-1)..(panel.width+1)).each do |w|
        unless self.width == w and self.height == h
          unless structure[w][h].nil?
            if structure[w][h].bomb_flag == 0 and !structure[w][h].is_open and !structure[w][h].is_bomb
              structure[w][h].is_open = true
              structure[w][h].user = user unless user.nil?
              structure[w][h].save
              target_panel << structure[w][h]
            end
          end
        end
      end
    end

    unless target_panel.size <= 0
      target_panel.each do |t|
        self.open_target_panels t, user
      end
    end
    return target_panel
  end

  def game_over
    Panel.transaction do
      # Lock Record
      lock = Panel.where(room_id: self.room.id).all(lock: true)
      # Update All
      Panel.update_all("is_open = true", room_id: self.room.id)
    end
  end

  def after_save_clear_cache
    self.room.clear_structure_cache
  end
end
