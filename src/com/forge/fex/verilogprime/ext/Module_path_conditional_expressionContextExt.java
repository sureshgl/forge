package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_path_conditional_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Module_path_conditional_expressionContextExt extends AbstractBaseExt {

	public Module_path_conditional_expressionContextExt(Module_path_conditional_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Module_path_conditional_expressionContext getContext() {
		return (Module_path_conditional_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).module_path_conditional_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Module_path_conditional_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Module_path_conditional_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}