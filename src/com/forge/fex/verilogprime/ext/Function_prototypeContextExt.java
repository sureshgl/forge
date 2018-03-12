package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Function_prototypeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Function_prototypeContextExt extends AbstractBaseExt {

	public Function_prototypeContextExt(Function_prototypeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Function_prototypeContext getContext() {
		return (Function_prototypeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).function_prototype());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Function_prototypeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Function_prototypeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}