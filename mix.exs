defmodule MetadataLogger.Plug.MixProject do
  use Mix.Project

  def project do
    [
      app: :metadata_logger_plug,
      version: "0.1.1-dev",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # hex
      description: "Plug Middleware to log request and response into in metadata",
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.5"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/elixir-metadata-logger/metadata_logger_plug",
        "Changelog" =>
          "https://github.com/elixir-metadata-logger/metadata_logger_plug/blob/master/CHANGELOG.md"
      },
      maintainers: ["Chulki Lee"]
    ]
  end
end
