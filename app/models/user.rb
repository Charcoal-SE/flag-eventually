class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :flag_queues

  after_create do
    f = FlagQueue.new
    f.user = self
    f.name = "Queue"
    f.save!

    Rails.logger.info "Created flag queue #{f.id} for new user #{self.id}"
  end

  def active_for_authentication? 
    super && approved? 
  end

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end
end
