package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Method_prototypeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Method_prototypeContextExt extends AbstractBaseExt {

	public Method_prototypeContextExt(Method_prototypeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Method_prototypeContext getContext() {
		return (Method_prototypeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).method_prototype());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Method_prototypeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Method_prototypeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}