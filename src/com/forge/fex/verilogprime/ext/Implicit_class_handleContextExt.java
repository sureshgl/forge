package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Implicit_class_handleContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Implicit_class_handleContextExt extends AbstractBaseExt {

	public Implicit_class_handleContextExt(Implicit_class_handleContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Implicit_class_handleContext getContext() {
		return (Implicit_class_handleContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).implicit_class_handle());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Implicit_class_handleContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Implicit_class_handleContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}