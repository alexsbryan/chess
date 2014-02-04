class Employee
  attr_accessor :salary, :boss
  def initialize name, title, salary, boss = nil
    @name = name
    @title = title
    @salary = salary
    @boss = boss
    @boss.add_emp_to_manager(self) unless boss.nil?
  end

  def bonus(multiplier)
    @salary * multiplier
  end

end


class Manager < Employee
  attr_accessor :list_of_employees
  def initialize name, title, salary, boss = nil, list_of_employees = []
    @list_of_employees = list_of_employees
    super(name, title, salary, boss)
    add_boss_to_employee
  end

  def add_emp_to_manager(employee)
    @list_of_employees << employee
  end

  def add_boss_to_employee
    @list_of_employees.each do |employee|
      employee.boss = self
    end
  end

  def bonus(multiplier)
    sub_employee_sal * multiplier
  end

  def sub_employee_sal
    tot_salary = 0
    @list_of_employees.each do |emp|
      if emp.is_a?(Manager)
        tot_salary += emp.salary
        tot_salary += emp.sub_employee_sal
      else
        tot_salary += emp.salary
      end
    end

    tot_salary
  end

end


if __FILE__ == $PROGRAM_NAME
  m = Manager.new(:John, :big_boss, 100)

end