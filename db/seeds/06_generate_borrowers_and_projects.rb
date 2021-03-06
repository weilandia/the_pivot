class BorrowersProjectsSeed
  def self.generate_borrowers
    @i = 0

    test_borrower = User.new(fullname: "Borrower", email: "borrower@lendingowl.com", password: "password")
    if test_borrower.save
      puts "Created User: #{test_borrower.fullname}."
      borrower = Borrower.new(borrower_params(test_borrower))
      if borrower.save
        puts "Created Borrower: #{borrower.id}."
        build_borrower_dashboard(test_borrower, borrower)
      end
    end

    275.times do
      fullname = Faker::Name.name
      email = Faker::Internet.free_email(fullname.split[0])
      user = User.new(fullname: fullname, email: email, password: "password")
      if user.save
        puts "Created User: #{user.fullname}."
        borrower = Borrower.new(borrower_params(user))
        if borrower.save
          puts "Created Borrower: #{borrower.id}."
          build_borrower_dashboard(user, borrower)
        end
      end
    end
  end

private
  def self.borrower_params(user)
    { annual_income: 0,
      monthly_housing: 0,
      monthly_credit_pmt: 0,
      dependents: 0}
  end

  def self.build_borrower_dashboard(user, borrower)
    user.roles << Role.find_by(name:"borrower")
    user.borrower = borrower
    date = Faker::Time.between(DateTime.now - 700, DateTime.now - 2)
    user.update(created_at: date, updated_at: date)
    countries = country_ids

    2.times do
      project = borrower.projects.create(name:Faker::Book.title, goal: (10..500).step(5).to_a.sample, description:Faker::Lorem.paragraph, category_id: Category.all[@i].id, country_id: countries.sample, image: "https://source.unsplash.com/random")
      puts "Created Project: #{project.name}, #{project.goal}."
      @i += 1
      if @i == 10 then @i = 0 end
    end
  end

  def self.category_ids
    Category.pluck(:id)
  end

  def self.country_ids
    Country.pluck(:id)
  end
end

BorrowersProjectsSeed.generate_borrowers
