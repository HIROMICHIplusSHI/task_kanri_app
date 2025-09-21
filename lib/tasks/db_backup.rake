namespace :db do
  desc "Create backup of development database"
  task backup: :environment do
    if Rails.env.development?
      timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
      backup_file = "db/backups/development_backup_#{timestamp}.sql"

      # Create backup directory if it doesn't exist
      FileUtils.mkdir_p("db/backups")

      # Create backup
      system("docker-compose exec -T db mysqldump -u root -ppassword myapp_development > #{backup_file}")
      puts "Database backed up to #{backup_file}"
    else
      puts "Backup only available in development environment"
    end
  end

  desc "Restore from backup"
  task :restore, [:backup_file] => :environment do |t, args|
    if Rails.env.development? && args[:backup_file]
      if File.exist?(args[:backup_file])
        system("docker-compose exec -T db mysql -u root -ppassword myapp_development < #{args[:backup_file]}")
        puts "Database restored from #{args[:backup_file]}"
      else
        puts "Backup file not found: #{args[:backup_file]}"
      end
    else
      puts "Usage: rake db:restore[path/to/backup.sql] (development only)"
    end
  end
end