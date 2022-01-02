class Performance::CyclingController < ApplicationController
  before_action :authenticate_user!

  def critical_power
    nyi!
  end

  def power_curve
    nyi!
  end

  def activities
    scope = Performance::CyclingActivities.exec(query_params!, {
      current_user: current_user
    })

    props = {
      average_cadence: "sum(activities.average_cadence * activities.moving_time) / sum(activities.moving_time)",
      average_calories_burned: "sum(activities.calories_burned * activities.moving_time) / sum(activities.moving_time)",
      average_heart_rate: "sum(activities.average_heart_rate * activities.moving_time) / sum(activities.moving_time)",
      average_normalized_power: "sum(activities.cycling_normalized_power * activities.moving_time) / sum(activities.moving_time)",
      average_power: "sum(activities.average_power * activities.moving_time) / sum(activities.moving_time)",
      average_speed: "sum(activities.moving_time * activities.average_speed) / sum(activities.moving_time)",
      calories_burned: "sum(calories_burned)",
      count: "count(activities.id)",
      distance: "sum(activities.distance)",
      elevation_gain: "sum(elevation_gain)",
      elevation_loss: "sum(elevation_loss)",
      epoch: scope.group_values&.first,
      moving_time: "sum(activities.moving_time)",
      training_stress_score: "sum(activities.cycling_training_stress_score)"
    }.compact.transform_values { |val| Arel.sql(val) }

    result = scope.pluck(*props.values).map do |values|
      props.keys.zip(values).to_h
    end

    render json: result, status: :ok
  end
end
