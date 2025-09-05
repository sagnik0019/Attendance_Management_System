# db/seeds.rb
puts "🌱 Seeding data..."

# Clear existing data
[Attendance, Student, Teacher, Admin, Subject, Semester, Department].each(&:destroy_all)

# Helper method to create dates
def random_date_within_semester(start_date, end_date)
  rand(start_date..end_date)
end

# 1. Create Departments
departments = [
  { name: "Computer Science and Engineering", code: "CS" },
  { name: "Electronics and Communication Engineering", code: "EC" },
  { name: "Mechanical Engineering", code: "ME" },
  { name: "Civil Engineering", code: "CE" },
  { name: "Electrical and Electronics Engineering", code: "EE" }
]

departments.each { |dept| Department.create!(dept) }
puts "✅ Departments created"

# 2. Create Semesters
semesters = [
  { name: "1st Semester" },
  { name: "2nd Semester" },
  { name: "3rd Semester" },
  { name: "4th Semester" },
  { name: "5th Semester" },
  { name: "6th Semester" },
  { name: "7th Semester" },
  { name: "8th Semester" }
]

semesters.each { |sem| Semester.create!(sem) }
puts "✅ Semesters created"

# 3. Create Subjects for each department-semester combination
subjects_data = {
  "CS" => {
    "1st Semester" => ["Engineering Mathematics-I", "Engineering Physics", "Basic Electrical Engineering"],
    "3rd Semester" => ["Data Structures", "Discrete Mathematics", "Digital Electronics"],
    "5th Semester" => ["Database Systems", "Operating Systems", "Computer Networks"],
    "7th Semester" => ["Artificial Intelligence", "Cloud Computing", "Big Data Analytics"]
  },
  "EC" => {
    "1st Semester" => ["Engineering Mathematics-I", "Engineering Chemistry", "Basic Electronics"],
    "3rd Semester" => ["Signals and Systems", "Electronic Circuits", "Electromagnetic Theory"],
    "5th Semester" => ["Digital Communication", "Microprocessors", "VLSI Design"],
    "7th Semester" => ["Wireless Communication", "Embedded Systems", "IoT Fundamentals"]
  }
}

subjects_data.each do |dept_code, sem_data|
  department = Department.find_by(code: dept_code)
  sem_data.each do |sem_name, subjects|
    semester = Semester.find_by(name: sem_name)
    subjects.each do |subject_name|
      Subject.create!(
        name: subject_name,
        code: "#{dept_code}#{rand(100..300)}",
        department: department,
        semester: semester
      )
    end
  end
end
puts "✅ Subjects created"

# 4. Create Admin
admins = [
  {  email: "rajesh.kumar@college.edu", password: "123456", password_confirmation: "123456" }
]

admins.each { |admin| Admin.create!(admin) }
puts "✅ Admin created"

# 5. Create Teachers
teachers = [
  { name: "Prof. Sunita Sharma", email: "sunita.sharma@college.edu", password: "123456", password_confirmation: "123456" },
  { name: "Dr. Amit Patel", email: "amit.patel@college.edu", password: "123456", password_confirmation: "123456" },
  { name: "Prof. Priya Singh", email: "priya.singh@college.edu", password: "123456", password_confirmation: "123456" }
]

teachers.each { |teacher| Teacher.create!(teacher) }
puts "✅ Teachers created"

# 6. Create Students with 10-digit unique roll numbers
used_roll_numbers = Set.new

# Generate unique 10-digit roll number
def generate_roll_number(used_numbers)
  loop do
    number = rand(10_000_000_00..99_999_999_99).to_s
    unless used_numbers.include?(number)
      used_numbers.add(number)
      return number
    end
  end
end

cs_department = Department.find_by(code: "CS")
ec_department = Department.find_by(code: "EC")
current_semester = Semester.find_by(name: "5th Semester")

# Create CS students
20.times do |i|
  Student.create!(
    name: ["Aarav", "Diya", "Vihaan", "Ananya", "Reyansh", "Saanvi", "Arjun", "Ishaan", "Myra", "Advait"].sample + " " +
           ["Sharma", "Patel", "Singh", "Kumar", "Verma", "Gupta", "Joshi", "Malhotra", "Reddy", "Nair"].sample,
    email: "cs#{i+1}@student.college.edu",
    password: "123456",
    password_confirmation: "123456",
    roll_number: generate_roll_number(used_roll_numbers),
    department: cs_department,
    semester: current_semester
  )
end

# Create EC students
20.times do |i|
  Student.create!(
    name: ["Krish", "Anika", "Dhruv", "Kiara", "Atharv", "Pari", "Kabir", "Aanya", "Vivaan", "Tara"].sample + " " +
           ["Mehta", "Choudhary", "Bose", "Banerjee", "Chatterjee", "Das", "Sen", "Mukherjee", "Dutta", "Ghosh"].sample,
    email: "ec#{i+1}@student.college.edu",
    password: "123456",
    password_confirmation: "123456",
    roll_number: generate_roll_number(used_roll_numbers),
    department: ec_department,
    semester: current_semester
  )
end
puts "✅ Students created"

# 7. Create Sample Attendance Records
puts "⏳ Creating attendance records (this may take a moment)..."

cs_subjects = Subject.joins(:department).where(departments: { code: "CS" }, semester: current_semester)
ec_subjects = Subject.joins(:department).where(departments: { code: "EC" }, semester: current_semester)

# Create attendance for last 30 days
30.times do |i|
  date = i.days.ago.to_date

  # For CS department
  cs_students = Student.where(department: cs_department, semester: current_semester)
  teacher = Teacher.all.sample
  subject = cs_subjects.sample

  cs_students.each do |student|
    Attendance.create!(
      student: student,
      teacher: teacher,
      subject: subject,
      semester: current_semester,
      attendance_date: date,
      present: [true, true, true, false].sample # 75% chance of being present
    )
  end

  # For EC department
  ec_students = Student.where(department: ec_department, semester: current_semester)
  teacher = Teacher.all.sample
  subject = ec_subjects.sample

  ec_students.each do |student|
    Attendance.create!(
      student: student,
      teacher: teacher,
      subject: subject,
      semester: current_semester,
      attendance_date: date,
      present: [true, true, false].sample # 66% chance of being present
    )
  end
end

puts "✅ Attendance records created"
puts "🎉 Seeding complete!"
