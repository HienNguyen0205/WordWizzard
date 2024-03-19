const sendResponse = ({
    res,
    status = 200,
    success = true,
    message,
    data,
    ...rest
  }) => {
    res.status(status).send({
      success: success,
      message: message,
      data: data,
      ...rest,
    });
  };
  
export default sendResponse;