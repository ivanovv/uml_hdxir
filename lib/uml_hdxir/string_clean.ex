defmodule UmlHdxir.StringClean do

  def clean(str) do
    str
    |> String.downcase
    |> device_ua_filter
    |> non_printable_filter
    |> String.trim
  end

  def extra_clean(str) do
    str
    |> String.downcase
    |> extra_ua_filter
    |> non_printable_filter
    |> String.trim
  end

  defp device_ua_filter(str), do: Regex.replace(~r{[ _\\#\-,./:"']}, str, "")
  defp extra_ua_filter(str), do: Regex.replace(~r{[ ]}, str, "")
  defp non_printable_filter(str), do: Regex.replace(~r{[^(\x20-\x7F)]*}, str, "")
end