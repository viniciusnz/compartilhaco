class CampaignSpreaderWorker
  include Sidekiq::Worker

  def perform campaign_spreader_id
    campaign_spreader = CampaignSpreader.find(campaign_spreader_id)
    campaign_spreader.create_segment_subscription
  end
end
