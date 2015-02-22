class StatusesController < ApplicationController
  respond_to :json
  def show
    today = 1.day.ago..Time.zone.now
    status = {
      healthy: true,
      gif_count: Gif.count,
      new_imported_today: Gif.where(created_at: today).count,
      new_published_today: Gif.visible.where(created_at: today).count,
      new_shared_today: Gif.visible.where(shared: true, created_at: today).count,
      visile: Gif.visible.count,
      failed_jobs: Delayed::Job.where('attempts > 1').count
    }
    respond_with status
  end
end
