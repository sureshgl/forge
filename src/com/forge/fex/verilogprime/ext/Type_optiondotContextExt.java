package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Type_optiondotContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Type_optiondotContextExt extends AbstractBaseExt {

	public Type_optiondotContextExt(Type_optiondotContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_optiondotContext getContext() {
		return (Type_optiondotContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_optiondot());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_optiondotContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_optiondotContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}