require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    let(:another_user) { create(:user) }
    let(:another_question) { create(:question, user: another_user) }

    it 'returns true, if is author of post' do
      expect(user).to be_author_of(question)
    end

    it 'returns false, if is NOT author of post' do
      expect(user).to_not be_author_of(another_question)
    end
  end

  describe '#up_vote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:own_question) { create(:question, user: user) }
    let(:answer) { create(:answer) }

    it 'should increase up votes for question' do
      expect(question.up_votes).to eq 0
      user.up_vote(question)
      expect(question.up_votes).to eq 1
      expect(question.rating).to eq 1
    end

    it 'should increase up votes for answer' do
      expect(answer.up_votes).to eq 0
      user.up_vote(answer)
      expect(answer.up_votes).to eq 1
    end

    it 'should raise error if user try to vote own question' do
      expect { user.up_vote(own_question) }.to raise_error(Exceptions::OwnerVotedError)
    end

    it 'when up vote, should create user vote' do
      expect(Vote.count).to eq 0
      user.up_vote(question)
      expect(Vote.count).to eq 1

      vote = Vote.first
      expect(vote.voteable). to eq question
      expect(vote.user).to eq user
      expect(vote.score).to eq 1
    end

    it 'when down vote, should create user vote' do
      expect(Vote.count).to eq 0
      user.down_vote(question)
      expect(Vote.count).to eq 1

      vote = Vote.first
      expect(vote.voteable). to eq question
      expect(vote.user).to eq user
      expect(vote.score).to eq -1
    end

    it 'should allow user to up vote question only once' do
      user.up_vote(question)
      expect { user.up_vote(question) }.to raise_error(Exceptions::AlreadyVotedError)
    end

    it 'should allow user to up vote question only once' do
      user.down_vote(question)
      expect { user.down_vote(question) }.to raise_error(Exceptions::AlreadyVotedError)
    end
  end

  describe '#down_vote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:own_question) { create(:question, user: user) }

    it 'should increase down votes of question by one' do
      expect(question.down_votes).to eq 0
      user.down_vote(question)
      expect(question.down_votes).to eq 1
      expect(question.rating).to eq -1
    end

    it 'should increase down votes of answer by one' do
      expect(answer.down_votes).to eq 0
      user.down_vote(answer)
      expect(answer.down_votes).to eq 1
    end

    it 'should raise error if user try to vote own question' do
      expect { user.down_vote(own_question) }.to raise_error(Exceptions::OwnerVotedError)
    end
  end

  describe '#un_vote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when up voted first' do
      it 'delete vote' do
        expect(Vote.count).to eq 0
        user.up_vote(question)
        expect(Vote.count).to eq 1

        vote = Vote.first
        expect(vote.score).to eq 1

        user.un_vote(question)
        expect(Vote.count).to eq 0
      end

      it 'should decrease up votes of voteable by one' do
        expect(question.up_votes).to eq 0
        user.up_vote(question)
        expect(question.up_votes).to eq 1
        user.un_vote(question)
        expect(question.up_votes).to eq 0
      end
    end

    context 'when down voted first' do
      it 'delete vote' do
        expect(Vote.count).to eq 0
        user.down_vote(question)
        expect(Vote.count).to eq 1

        vote = Vote.first
        expect(vote.score).to eq -1

        user.un_vote(question)
        expect(Vote.count).to eq 0
      end

      it 'should decrease down votes of voteable by one' do
        expect(question.down_votes).to eq 0
        user.down_vote(question)
        expect(question.down_votes).to eq 1
        user.un_vote(question)
        expect(question.down_votes).to eq 0
      end
    end
  end

  describe '#voted?' do
    let(:user) { create(:user) }
    let(:voteable) { create(:question) }

    it 'should check if voter up voted voteable' do
      user.up_vote(voteable)
      expect(user.voted?(voteable)).to be true
    end

    it 'should check if voter down voted voteable' do
      user.down_vote(voteable)
      expect(user.voted?(voteable)).to be true
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }


    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization =  User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }
        let(:twitter_auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'generates user email if is empty' do
          user = User.find_for_oauth(twitter_auth)
          expect(user.email).to_not be_empty
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'create authorizations with provider and uid' do
          authorization =  User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '#email_verified?' do
    let(:twitter_user) { create(:user, email: 'new@user.com') }
    let(:user) { create(:user) }
    context 'when email verified' do
      it 'return false' do
        expect(twitter_user.email_verified?).to eq(false)
      end
    end

    context 'when email was not verified' do
      it 'return true' do
        expect(user.email_verified?).to eq(true)
      end
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }
    it 'should send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end
  end
end
