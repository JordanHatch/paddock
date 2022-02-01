class VersionHistoryPresenter
  def initialize(versions)
    @versions = versions
  end

  def items
    versions.map do |item|
      VersionHistoryItemPresenter.new(item)
    end
  end

  private

  attr_reader :versions
end
