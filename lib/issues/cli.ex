defmodule Issues.CLI do
	@default_count 4

	@moduledoc """
	documentation for the below function goes here
	"""
	def run(argv) do
		argv
		|> parse_args	
		|> process
	end

	@moduledoc """
	documentation for the below function goes here
	"""
	def parse_args(argv) do
		parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
		case parse do
			{[help: true], _, _} -> :help
			{_, [user, project, count], _} -> {user, project, String.to_integer count}
			{_, [user, project], _} -> {user, project, @default_count}
			_ -> :help
		end
	end

	@moduledoc """
	documentation for the below function goes here
	"""
	def process(:help) do
		IO.puts """
		usage: issues <user> <project> [count | #{@default_count}]
		"""
		System.halt 0
	end

	def process({user, project, count}) do
		Issues.GithubIssues.fetch(user, project)
		|> decode_response
		|> convert_to_list_of_hashdicts
		|> sort_into_ascending_order
		|> Enum.take(count)
	end

	def decode_response({:ok, body}) do
		body
	end
	def decode_response({:not_usable, response}) do
		message = response["message"]
		IO.puts "Error fetching from Github: #{message}"
		System.halt 2
	end
	def decode_response({:error, reason}) do
		IO.puts "An error has ocurred: #{reason}"
		System.halt 0
	end

	def convert_to_list_of_hashdicts(list_of_lists) do
		list_of_lists
		|> Enum.map(& Enum.into(&1, HashDict.new))
	end

	def sort_into_ascending_order(list_of_hashdicts) do
		list_of_hashdicts
		|> Enum.sort(& &1["created_at"] <= &2["created_at"])
	end	
end