module Search
  class Issue
    attr_reader :params

    Filter = Struct.new(:id, :type, :scope, :options)

    FilterSprintID = Filter.new(
      :sprint_id,
      :list,
      ->(scope, params) {
        scope.for_sprint_id(params[:sprint_id])
      },
      -> { Sprint.all.map {|sprint| [ sprint.name, sprint.id ] }.to_h },
    )

    FilterGroupID = Filter.new(
      :group_id,
      :list,
      ->(scope, params) {
        scope.for_group_id(params[:group_id])
      },
      -> { Group.in_order.map {|group| [ group.name, group.id ] }.to_h },
    )

    FilterIdentifier = Filter.new(
      :identifier,
      :boolean,
      ->(scope, _params) {
        scope.with_identifier
      },
      -> { %i{true false} },
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
      defined_filters.map {|filter|
        [ filter.id, filter ]
      }.to_h
    end

    def active_filters
      defined_filters.select {|filter|
        params[filter.id].present? &&
          params[filter.id] != 'false'
      }
    end

    private

    def base_scope
      ::Issue.published.includes(:team)
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
        active_filters.map(&:scope)
      )
    end

    def merge_relations(relations)
      relations.inject(base_scope) {|output, scope|
        scope.call(output, params)
      }
    end

  end
end
