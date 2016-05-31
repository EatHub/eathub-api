defmodule EathubApi.V1.StepControllerTest do
  use EathubApi.ConnCase

  alias EathubApi.Step
  @valid_attrs %{idPicture: "some content", idRecipe: "some content", text: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, v1_step_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    step = Repo.insert! %Step{}
    conn = get conn, v1_step_path(conn, :show, step)
    assert json_response(conn, 200)["data"] == %{"id" => step.id,
      "idRecipe" => step.idRecipe,
      "text" => step.text,
      "idPicture" => step.idPicture}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, v1_step_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, v1_step_path(conn, :create), step: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Step, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, v1_step_path(conn, :create), step: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    step = Repo.insert! %Step{}
    conn = put conn, v1_step_path(conn, :update, step), step: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Step, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    step = Repo.insert! %Step{}
    conn = put conn, v1_step_path(conn, :update, step), step: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    step = Repo.insert! %Step{}
    conn = delete conn, v1_step_path(conn, :delete, step)
    assert response(conn, 204)
    refute Repo.get(Step, step.id)
  end
end
