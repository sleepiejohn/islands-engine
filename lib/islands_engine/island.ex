defmodule IslandsEngine.Island do
  alias __MODULE__
  alias IslandsEngine.Coordinate

  @type island_type ::
          :square
          | :atoll
          | :dot
          | :l_shape
          | :s_shape
  @type t :: %Island{
          coordinates: MapSet.t(Coordinate.t()),
          hit_coordinates: MapSet.t(Coordinate.t())
        }
  @type invalid :: {:error, :invalid_shape, any}

  @enforce_keys ~w(coordinates hit_coordinates)a
  defstruct @enforce_keys

  @doc """
  Create a new Island based on a type and its starting position on a grid.

  ## Examples

      iex> {:ok, coord} = IslandsEngine.Coordinate.new(row: 1, col: 1)
      iex> IslandsEngine.Island.new(:square, coord)
      %IslandsEngine.Island{coordinates: MapSet.new([%IslandsEngine.Coordinate{col: 1, row: 1},
         %IslandsEngine.Coordinate{col: 1, row: 2}, %IslandsEngine.Coordinate{col: 2, row: 1},
         %IslandsEngine.Coordinate{col: 2, row: 2}]),
         hit_coordinates: MapSet.new()}

      iex> {:ok, coord} = IslandsEngine.Coordinate.new(row: 1, col: 1)
      iex> IslandsEngine.Island.new(:circle, coord)
      {:error, :invalid_island_type, :circle}
  """
  @spec new(island_type(), Coordinate.t()) :: Island.t() | Coordinate.invalid() | Island.invalid()
  def new(type, starting_coordinate) do
    with offsets when is_list(offsets) <- offsets(type),
         coordinates when is_struct(coordinates) <- add_coord(offsets, starting_coordinate) do
      %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}
    else
      error -> error
    end
  end

  def overlaps?(island, new_island),
    do: not MapSet.disjoint?(island.coordinates, new_island.coordiantes)

  @spec guess(Island.t(), Coordinate.t()) :: :miss | {:hit, Island.t()}
  def guess(island, coordinate) do
    if MapSet.member?(island.coordinates, coordinate) do
      hitted = %Island{island | hit_coordinates: MapSet.put(island.hit_coordinates, coordinate)}
      {:hit, hitted}
    else
      :miss
    end
  end

  defp add_coord(offsets, starting_coordinate) do
    Enum.reduce_while(offsets, MapSet.new(), fn {row_off, col_off}, acc ->
      case Coordinate.move(starting_coordinate, row: row_off, col: col_off) do
        {:ok, coordinate} -> {:cont, MapSet.put(acc, coordinate)}
        {:error, :invalid_coordinates} = err -> {:halt, err}
      end
    end)
  end

  # implementation note: we calculate the positions of each shape
  # on a 3x3 grid, enough to fit all shapes, starting at position 0, 0
  # so wherever we put the shape we can add the starting position to
  # each "offset" calculated on the small grid.
  defp offsets(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  defp offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  defp offsets(:dot), do: [{0, 0}]
  defp offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  defp offsets(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  # implementation note: returns the given shape to easy debugging
  defp offsets(type), do: {:error, :invalid_island_type, type}
end
