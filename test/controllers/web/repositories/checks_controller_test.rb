# frozen_string_literal: true

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @check = repository_checks(:one)

    sign_in users(:one)
  end

  test 'should show check' do
    get repository_check_path(@check.repository, @check)

    assert_response :success
  end

  test 'should create check' do
    repo = repositories(:one)

    assert_difference -> { repo.checks.count } do
      post repository_checks_path(repo)
    end

    assert_redirected_to repository_path(repo)
    assert_enqueued_with job: RepositoryCheckerJob
  end
end
