defmodule Habanero.ScoreControllerTest do
  use Habanero.ConnCase

  alias Habanero.Score
  @valid_attrs %{img_url: "some content", rate: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, score_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    score = Repo.insert! %Score{}
    conn = get conn, score_path(conn, :show, score)
    assert json_response(conn, 200)["data"] == %{"id" => score.id,
      "rate" => score.rate,
      "img_url" => score.img_url}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, score_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, score_path(conn, :create), score: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Score, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, score_path(conn, :create), score: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    score = Repo.insert! %Score{}
    conn = put conn, score_path(conn, :update, score), score: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Score, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    score = Repo.insert! %Score{}
    conn = put conn, score_path(conn, :update, score), score: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    score = Repo.insert! %Score{}
    conn = delete conn, score_path(conn, :delete, score)
    assert response(conn, 204)
    refute Repo.get(Score, score.id)
  end
end
