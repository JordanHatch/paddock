module Search
  class Issue
    attr_reader :params

    Filter = Struct.new(:id, :type, :scope, :options)

    FilterSprintID = Filter.new(
      :sprint_id,
      :multi_select,
      lambda { |scope, params|
        scope.for_sprint_id(params[:sprint_id])
      },
      -> { Sprint.all.to_h { |sprint| [sprint.name, sprint.id] } },
    )

    FilterGroupID = Filter.new(
      :group_id,
      :multi_select,
      lambda { |scope, params|
        scope.for_group_ids([params[:group_id]].flatten)
      },
      -> { Group.in_order.to_h { |group| [group.name, group.id] } },
    )

    FilterIdentifier = Filter.new(
      :identifier,
      :select,
      lambda { |scope, params|
        case params[:identifier].to_i
        when 1
          scope.with_identifier
        when 0
          scope.without_identifier
        end
      },
      lambda {
        {
          'Linked to DevOps' => 1,
          'Not linked to DevOps' => 0,
        }
      },
    )

    def initialize(params: {})
      @params = params.slice(*defined_filter_ids)
    end

    def results
      @results ||= apply_filters.all
    end

    def results_count
      results.count
    end

    def available_filters
      defined_filters.to_h do |filter|
        [filter.id, filter]
      end
    end

    def active_filters
      defined_filters.select do |filter|
        params[filter.id].present? &&
          params[filter.id] != 'false'
      end
    end

    def selected?(filter_id, value)
      params[filter_id].present? &&
        ((params[filter_id].is_a?(Array) && params[filter_id].include?(value.to_s)) || params[filter_id] == value.to_s)
    end

    private

    def base_scope
      ::Issue.published.includes(:sprint_update, :team, :sprint)
    end

    def defined_filters
      [
        FilterSprintID,
        FilterGroupID,
        FilterIdentifier,
      ]
    end

    def defined_filter_ids
      defined_filters.map(&:id)
    end

    def apply_filters
      merge_relations(
        active_filters.map(&:scope),
      )
    end

    def merge_relations(relations)
      relations.inject(base_scope) do |output, scope|
        scope.call(output, params)
      end
    end
  end
end
