# frozen_string_literal: true

class Repository < ApplicationRecord
  include AASM
  extend Enumerize

  ALLOWED_LANGUAGES = %w[javascript ruby].freeze

  enumerize :language, in: ALLOWED_LANGUAGES

  belongs_to :user

  has_many :checks, dependent: :destroy

  validates :github_id, presence: true, uniqueness: true

  aasm :state do
    state :created, initial: true
    state :fetching
    state :fetched
    state :failed

    event :fetch do
      transitions from: %i[created fetched failed], to: :fetching
    end

    event :mark_as_fetched do
      transitions from: :fetching, to: :fetched
    end

    event :mark_as_failed do
      transitions from: :fetching, to: :failed
    end
  end
end
