defmodule Habanero.Router do
  use Habanero.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Habanero do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Habanero do
    pipe_through :api

    resources "/subjects", SubjectController, except: [:new, :edit]
    resources "/drawings", DrawingController, except: [:new, :edit]
  end
end
