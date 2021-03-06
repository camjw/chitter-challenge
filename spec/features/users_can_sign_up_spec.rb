feature 'the user can sign up to chitter' do
  scenario 'from the home page' do
    sign_up_for_chitter('Borace', 'borace01', 'borace@mail.com', 'password')
    expect(page).to have_content 'You are now signed up to Chitter!'
    expect(retrieve_settings.users.sign_in('borace01', 'password')).to eq true
  end
end
