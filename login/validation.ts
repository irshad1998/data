import { body, check } from "express-validator/src/middlewares/validation-chain-builders";

export const adminLoginValidation = () => {
  return [
    check('mobile')
    .if(check('otp').exists())
    .notEmpty()
    .withMessage("Mobile number can't be empty")
    .trim()
    .escape(),
    check('email')
      .trim()
      .escape()
      .isEmail()
      .trim()
      .escape()
      .optional(),
      body('otp')
      .if(check('mobile').exists())
      .custom((value)=> typeof value !== 'string')
      .withMessage("Invalid OTP")
      .if((value: any) => value !== undefined) 
      .isLength({ min: 6, max: 6 }).withMessage('OTP must be 6 digits long')
      .trim()
      .escape()
      .optional(),
    check('password')
      .if(check('email')
        .exists())
      .notEmpty()
      .withMessage("Password can't be empty")
      .trim()
      .escape(),
  ];
};
