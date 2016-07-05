shared_examples_for 'Voted' do
  object = described_class.controller_name.classify.downcase

  describe 'Post #up_vote' do
    context "current user is not the #{object} author" do
      sign_in_user
      let(:voteable) { create(object.to_sym) }

      before { post :up_vote, id: voteable }

      it "increment #{object} up_vote value" do
        expect(voteable.reload.up_votes).to eq 1
      end

      it 'return ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context "#{object} author is the current user" do
      sign_in_user
      let(:voteable) { create(object.to_sym, user: @user) }

      before { post :up_vote, id: voteable }

      it "not increment #{object} up_vote value" do
        expect(voteable.reload.up_votes).to eq 0
      end

      it 'return forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when up voting twice' do
      sign_in_user
      let(:voteable) { create(object.to_sym) }

      def send_up_vote
        post :up_vote, id: voteable
      end

      before do
        send_up_vote
        send_up_vote
      end

      it "not increment #{object} up_vote twice" do
        expect(voteable.reload.up_votes).to eq 1
      end

      it 'return forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'Post #un_vote' do
    context 'when already up voted' do
      sign_in_user

      let(:voteable) { create(object.to_sym) }

      it "reset #{object} up_votes" do
        post :up_vote, id: voteable
        expect(voteable.reload.up_votes).to eq 1

        post :un_vote, id: voteable
        expect(voteable.reload.up_votes).to eq 0
      end

      it 'return ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when already down voted' do
      sign_in_user

      let(:voteable) { create(object.to_sym) }

      it "reset #{object} up_votes" do
        post :down_vote, id: voteable
        expect(voteable.reload.down_votes).to eq 1

        post :un_vote, id: voteable
        expect(voteable.reload.down_votes).to eq 0
      end

      it 'return ok' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'Post #down_vote' do
    context "current user is not the #{object} author" do
      sign_in_user
      let(:voteable) { create(object.to_sym) }

      before { post :down_vote, id: voteable }

      it "should increase down votes of #{object} by one" do
        expect(voteable.reload.down_votes).to eq 1
      end

      it 'return ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context "#{object} author is the current user" do
      sign_in_user
      let(:voteable) { create(object.to_sym, user: @user) }

      before { post :down_vote, id: voteable }

      it "not increase down votes of #{object}" do
        expect(voteable.reload.down_votes).to eq 0
      end

      it 'return forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when down voting twice' do
      sign_in_user
      let(:voteable) { create(object.to_sym) }

      before do
        post :down_vote, id: voteable
        post :down_vote, id: voteable
      end

      it "not increment #{object} up_vote twice" do
        expect(voteable.reload.down_votes).to eq 1
      end

      it 'return forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
