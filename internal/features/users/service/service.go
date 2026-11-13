package service

type UsersRepository interface {
}

type UserService struct {
	usersRepository UsersRepository
}
