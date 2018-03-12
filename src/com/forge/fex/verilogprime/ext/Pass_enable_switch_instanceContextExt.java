package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pass_enable_switch_instanceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pass_enable_switch_instanceContextExt extends AbstractBaseExt {

	public Pass_enable_switch_instanceContextExt(Pass_enable_switch_instanceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pass_enable_switch_instanceContext getContext() {
		return (Pass_enable_switch_instanceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pass_enable_switch_instance());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pass_enable_switch_instanceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Pass_enable_switch_instanceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}