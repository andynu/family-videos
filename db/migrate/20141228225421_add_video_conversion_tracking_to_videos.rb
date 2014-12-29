class AddVideoConversionTrackingToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :conversion_duration, :double
    add_column :videos, :conversion_position, :double
    add_column :videos, :conversion_status, :string
  end
end
