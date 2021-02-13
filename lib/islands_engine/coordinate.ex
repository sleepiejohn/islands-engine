defmodule IslandsEngine.Coordinate do
  alias __MODULE__

  @type t :: %Coordinate{row: coordinate(), col: coordinate()}
  @type invalid :: {:error, :invalid_coordinates}
  @typep coordinate :: 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10

  @board_range 1..10

  @enforce_keys ~w(row col)a
  defstruct @enforce_keys

  defguardp are_within_range(row, col) when row in @board_range and col in @board_range

  # implementation note: I used Keywords since we can mistaken use row in the position of col and vice versa since they
  # are both numbers, so we give them names to distinguish
  @spec new(row: number(), col: number()) :: Coordinate.invalid() | {:ok, Coordinate.t()}
  @doc """
  Create a new coordinate with given row and col

  ## Examples

      iex> IslandsEngine.Coordinate.new(row: 1, col: 1)
      {:ok, %IslandsEngine.Coordinate{row: 1, col: 1}}

      iex> IslandsEngine.Coordinate.new(row: 11, col: 1)
      {:error, :invalid_coordinates}
  """
  def new(row: row, col: col) when are_within_range(row, col),
    do: {:ok, %Coordinate{row: row, col: col}}

  def new(_), do: {:error, :invalid_coordinates}

  def move(%Coordinate{row: row, col: col}, row: row_offset, col: col_offset) do
    new(row: row + row_offset, col: col + col_offset)
  end
end
