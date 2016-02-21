require "spec_helper"

describe "tasks_index" do
  context "with arguments" do
    before do
      visit tasks_path(q: {finished_eq: "1", user_country_eq: "DK"})

      expect(page).to have_http_status(:success)
      expect(current_path).to eq tasks_path
    end

    it "displays the correct hints" do
      expect(page.html).to include "<span class=\"hint\">Enter a part of the name of the user you are searching for.</span>"
      expect(page.html).to include "Task done"
      expect(page.html).to include "name=\"q[name_cont]\""
      expect(page.html).to include "method=\"get\""
      expect(page.html).to include "<option selected=\"selected\" value=\"1\">Finished</option>"
    end

    it "handels countries correctly" do
      country_select = find("#q_user_country_eq")
      expect(country_select["name"]).to eq "q[user_country_eq]"

      denmark_option = find("#q_user_country_eq option[value='DK']")
      expect(denmark_option["selected"]).to eq "selected"
    end

    it "handles sub models correctly" do
      label = find("label[for=q_user_user_roles_role_eq]")
      expect(label.text).to eq "Customer roles rank"
    end

    it "handels collections and selects correctly" do
      task_finished = find("#q_finished_eq")
      expect(task_finished["class"]).to eq "select optional"
      expect(task_finished["name"]).to eq "q[finished_eq]"

      finished_option = find("#q_finished_eq option[value='1']")

      expect(finished_option["selected"]).to eq "selected"
    end

    it "includes blank options by default for select and country" do
      expect(find("#q_user_country_eq option[value='']").text).to eq ""
      expect(find("#q_finished_eq option[value='']").text).to eq ""
    end

    it "allows custom inputs to be defined" do
      input = find("#q_custom_input")
      expect(input["class"]).to eq "string optional"
      expect(input["name"]).to eq "q[custom_input]"
      expect(input["type"]).to eq "text"
      expect(input["value"]).to eq ""
    end

    it "groups by _or_" do
      label = find("label[for='q_user_email_or_name_cont']")
      find("#q_user_email_or_name_cont")

      expect(label.text).to eq "Customer email or name contains"
    end

    it "shows the correct name for tripple attributes" do
      label = find("label[for='q_user_id_or_user_email_or_user_password_cont']")
      expect(label.text).to eq "Customer ID, customer email or customer password contains"
    end
  end

  context "registers given arguments" do
    it "registers default arguments" do
      visit tasks_path(set_default_arguments: true)
      name_cont = find("input[id=q_name_cont]")
      expect(name_cont.value).to eq "Test sample cont"
    end
  end
end
