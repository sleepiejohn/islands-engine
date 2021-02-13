defmodule IslandsEngine.Guesses do
  alias __MODULE__
  alias IslandsEngine.Coordinate

  @enforce_keys ~w(hits misses)a
  defstruct @enforce_keys

  @type t :: %IslandsEngine.Guesses{
          hits: MapSet.t(Coordinate.t()),
          misses: MapSet.t(Coordinate.t())
        }

  @spec new :: Guesses.t()
  def new do
    %Guesses{hits: MapSet.new(), misses: MapSet.new()}
  end

  @doc """
  Adds a hit or a miss to the Guesses

  ## Examples

      iex> guesses = IslandEngine.Guesses.new()
      iex> {:ok, coord} = IslandEngine.Coordinate.new(row: 1, col: 1)
      iex> IslandEngine.Guesses.add(IslandsEngine.Guesses.new(), :hit, coord)
      %IslandEngine.Guesses{hits: MapSet.new([coord]), misses: MapSet.new()}

      iex> guesses = IslandEngine.Guesses.new()
      iex> {:ok, coord} = IslandEngine.Coordinate.new(row: 1, col: 1)
      iex> IslandEngine.Guesses.add(IslandsEngine.Guesses.new(), :miss, coord)
      %IslandEngine.Guesses{hits: MapSet.new(), misses: MapSet.new([coord])}
  """
  @spec add(Guesses.t(), :hit | :miss, Coordinate.t()) :: Guesses.t()
  def add(guesses, :hit, coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  end

  def add(guesses, :miss, coordinate) do
    update_in(guesses.miss, &MapSet.put(&1, coordinate))
  end
end
