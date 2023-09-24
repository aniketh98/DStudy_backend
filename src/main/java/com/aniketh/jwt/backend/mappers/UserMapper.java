package com.aniketh.jwt.backend.mappers;

import com.aniketh.jwt.backend.dto.SignUpDto;
import com.aniketh.jwt.backend.dto.UserDto;
import com.aniketh.jwt.backend.entities.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserMapper {
    UserDto toUserDto(User user);

    @Mapping(target = "password", ignore = true)
    User signUpToUser(SignUpDto userDto);
}
