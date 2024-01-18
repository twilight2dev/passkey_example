import { prismaClient } from "../database";
import { v4 as uuidv4 } from "uuid";

export const userService = {
  async getUserById(userId: string) {
    return await prismaClient.user.findUnique({
      where: {
        id: userId,
      },
    });
  },

  async getUserByUsername(username: string) {
    return await prismaClient.user.findUnique({
      where: {
        username: username,
        
      },
    });
  },

  async removeUserWithUsername(username: string) {
    const deletedUser = await prismaClient.user.delete({
      where: {
        username: username,
      },
    });
    return deletedUser;
  },

  async createNewUser(username: string) {
    const id = uuidv4();
    const createdUser = await prismaClient.user.create({
      data: {
        id: id,
        username: username,
      },
    });
    return createdUser;
  },

  async markUserAsRegistered(userId: string) {
    const deletedUser = await prismaClient.user.update({
      where: {
        id: userId,
      },
      data: {
        registered: true,
      },
    });
    return deletedUser;
  },
};
