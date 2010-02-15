class User < ActiveRecord::Base
  is_gravtastic! :size => 50
  
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation
  
  attr_accessor :password
  before_save :prepare_password
  
  has_many :quotes, :dependent => :destroy
  has_many :friendships
  has_many :friends, :through => :friendships
  
  validates_presence_of :username
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\_@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  validates_exclusion_of :username, :in => %w( admin superuser following ), :message => "You can't take this username"
  
  def friends_of
    Friendship.all(:conditions => ["friend_id = ?", self.id]).map(&:user)
  end
  
  def add_friend(friend)
    friendship = friendships.build(:friend_id => friend.id)
    if !friendship.save
      logger.debug "User '#{friend.email}' already exists in the user's friendship list."
    end
  end
  
  def remove_friend(friend)
    friendship = Friendship.first :conditions => ["user_id = ? and friend_id = ?", self.id, friend.id]
    friendship.destroy if friendship
  end
  
  def is_friend?(friend)
    return self.friends.include? friend
  end
  
  def all_quotes
    Quote.all :conditions => ["user_id in (?)", friends.map(&:id).push(self.id)], :order => "created_at desc"
  end
  
  def self.find_by_search_query(q)
    User.all :conditions => ["username like ? OR email like ?", "%#{q}%", "%#{q}%"]
  end
  
  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.matching_password?(pass)
  end
  
  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end
  
  private
  
  def prepare_password
    unless password.blank?
      self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      self.password_hash = encrypt_password(password)
    end
  end
  
  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, password_salt].join)
  end
end
