class TicketType < ApplicationRecord

  def price_with_vat
    price * 1.25
  end

  def vat
    price * 0.25
  end

  def speaker?
    %w(lightning speaker short_talk).include? reference
  end

  def organizer?
    reference == "organizer"
  end

  def volunteer?
    reference == "volunteer"
  end

  def student?
    reference == "student"
  end

  def special_ticket?
    %w(sponsor volunteer organizer).include? reference
  end

  def normal_ticket?
    %w(early_bird full_price sponsor organizer).include? reference
  end

  def paying_ticket?
    price > 0
  end

  def discounted?
    price < TicketType.full_price.price
  end

  def has_fiken_product_reference?
    fiken_product_uri.present?
  end

  def self.current_normal_ticket
    early_bird_is_active? ? TicketType.early_bird : TicketType.full_price
  end

  def self.speaker
    find_by_reference("speaker")
  end

  def self.sponsor
    find_by_reference("sponsor")
  end

  def self.lightning
    find_by_reference("lightning")
  end

  def self.short_talk
    find_by_reference("short_talk")
  end

  def self.early_bird
    find_by_reference("early_bird")
  end

  def self.full_price
    find_by_reference("full_price")
  end

  def self.organizer
    find_by_reference("organizer")
  end

  def self.one_day
    find_by_reference("one_day")
  end

  def self.early_bird_is_active?
    Time.now < AppConfig.early_bird_ends && Ticket.count_by_ticket_type(TicketType.early_bird) < AppConfig.early_bird_ticket_limit
  end
end
