if Code.ensure_loaded?(Mix.Tasks.Coveralls.Post) do
  defmodule Mix.Tasks.Coveralls.SafePost do
    @shortdoc "Wrapper on `coveralls.post` that keeps tests from failing if it upload fails"

    @moduledoc """
    Suppress errors when a failure occurs uploading results to the coveralls service.

    The `coveralls.post` task causes the test task to fail if it cannot upload
    the report to the Coveralls server.  the Coveralls server fails.
    This creates false negatives, so we suppress the error.

    Accepts the same arguments as the main `coveralls.post` task.
    """
    use Mix.Task

    @preferred_cli_env :test

    def run(args) do
      task_output =
        try do
          Mix.Task.run("coveralls.post", args)
        rescue
          e in ExCoveralls.ReportUploadError ->
            Mix.shell().error("Failed Coveralls Upload: #{Exception.message(e)}")
        end

      # Mix uses the task output to determine exit status, so
      # capture the output and return it at the end. More specifically, if a
      # task returns from a `run` with a function or a list of functions,
      # they will be called before exit. The `mix test` return function calls
      # exit with a nonzero status if the tests failed, which is what we want.

      task_output
    end
  end
end
