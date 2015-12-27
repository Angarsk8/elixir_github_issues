defmodule Issues.GithubIssues do
	@issues_url Application.get_env :issues, :github_url
	@user_agent [{"User-agent", "Elixir dave@pragprog.com"}]

	def fetch(user, project) do
		github_url(user, project)
		|> HTTPoison.get(@user_agent)
		|> handle_response
	end	

	def github_url(user, project), do: "#{@issues_url}/repos/#{user}/#{project}/issues"

	def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
		{:ok, :jsx.decode body}
	end	
	def handle_response({:ok, %HTTPoison.Response{status_code: ___, body: body}}) do
		{:not_usable, :jsx.decode body}
	end
	def handle_response({:error, %HTTPoison.Error{reason: reason}}) do
		{:error, reason}
	end
end