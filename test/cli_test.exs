defmodule Issues.CliTest do
	use ExUnit.Case
	import Issues.CLI, only: [parse_args: 1, sort_into_ascending_order: 1, convert_to_list_of_hashdicts: 1]

	test "parse arguments when --help or -h is activated" do
		assert parse_args(["--help"]) == :help
		assert parse_args(["-h"]) == :help
	end

	test "parse arguments when only project and user are passed" do
		assert parse_args(["user", "project"]) == {"user", "project", 4}
	end

	test "parse arguments when all expected arguments are passed" do
		assert parse_args(["user", "project", "10"]) == {"user", "project", 10}
	end	

	test "ascending sorting works well" do
		issues = ~w/c a b/
		|> fake_created_at
		|> sort_into_ascending_order

		to_assert = for issue <- issues, do: issue["created_at"]
		assert to_assert == ~w/a b c/
	end

	defp fake_created_at(values) do
		(for value <- values, do: [{"created_at", value}, {"other_prop", "xxx"}])
		|> convert_to_list_of_hashdicts
	end
end	