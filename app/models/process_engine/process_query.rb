class ProcessEngine::ProcessQuery
  class << self

    def task_complete(task_id, options = {})
      task = ProcessEngine::ProcessTask.find(task_id)
      task.complete(options)
    end

    def task_get_all(options = {})
      taks = ProcessEngine::ProcessTask.all

      taks = taks.by_assignee(options[:assignee]) if options[:assignee]

      taks = taks.by_candidate_user(options[:candidate_user]) if options[:candidate_user]
      taks = taks.by_all_candidate_users(options[:all_candidate_users]) if options[:all_candidate_users]
      taks = taks.by_any_candidate_users(options[:any_candidate_users]) if options[:any_candidate_users]

      taks = taks.by_candidate_group(options[:candidate_group]) if options[:candidate_group]
      taks = taks.by_all_candidate_groups(options[:all_candidate_groups]) if options[:all_candidate_groups]
      taks = taks.by_any_candidate_groups(options[:any_candidate_groups]) if options[:any_candidate_groups]

      taks = taks.by_user(options[:user]) if options[:user]
      # e.g. options[:user_or_groups] = ["assignee123", ['cg1']]
      taks = taks.by_user_or_groups(*options[:user_or_groups]) if options[:user_or_groups]

      taks = taks.by_status(options[:status]) if options[:status]
      taks
    end

    def process_instance_start(process_defintion_slug, creator)
      pd = ProcessEngine::ProcessDefinition.find_by(slug: process_defintion_slug)
      pi = pd.process_instances.create(creator: creator)
      pi.start
    end

    def process_definition_get_all()
      ProcessEngine::ProcessDefinition.all
    end

  end
end
