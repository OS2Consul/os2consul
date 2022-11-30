require_dependency Rails.root.join('app', 'components', 'admin', 'hidden_table_actions_component').to_s

class Admin::CustomHiddenTableActionsComponent < Admin::HiddenTableActionsComponent
  private
    def edit_text
      t("admin.actions.edit")
    end

    def edit_path
      url_for({
        controller: "/#{record.model_name.plural}",
        action: :edit,
        id: record,
        only_path: true
      }.merge(request.query_parameters))
    end
end
